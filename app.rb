# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'csv'
require 'slim'
enable :method_override

get '/' do
  Memo.organize
  @table = CSV.table('csv/memo.csv', headers: %w[id title body])
  slim :top
end

post '/' do
  Memo.create(title: params['title'], body: params['body'])
  redirect to('/')
end

patch '/edit/update/:id' do |id|
  Memo.update(id, params['title'], params['body'])
  Memo.organize
  redirect to('/')
end

get '/edit/:id' do |id|
  id = id.to_i
  @title = Memo.title(id)
  @body = Memo.body(id)
  @id = id
  slim :edit
end

get '/new' do
  @title = '新規登録'
  @content = 'memo new'
  slim :new
end

get '/show/:id' do |id|
  @id = id.to_i
  @title = Memo.title(id)
  @body = Memo.body(id)
  slim :show
end

delete '/show/delete/:id' do |id|
  Memo.delete(id)
  redirect to('/')
end

class Memo
  class << self
    def title(id)
      id = id.to_i
      @table = CSV.table('csv/memo.csv', headers: %w[id title body])
      @table[:title][id]
    end

    def body(id)
      id = id.to_i
      @table = CSV.table('csv/memo.csv', headers: %w[id title body])
      @table[:body][id]
    end

    def create(title: title, body: body)
      CSV.table('csv/memo.csv', headers: %w[id title body])
      @new_id_num = @table.size
      if @table.first.nil?
        CSV.open('csv/memo.csv', 'w', headers: true) do |test|
          test << %w[id title body]
          test << [1, title, body]
        end

      else
        CSV.open('csv/memo.csv', 'a', headers: true) do |test|
          test << [@new_id_num, title, body]
        end
      end
    end

    def organize
      i = 0
      CSV.foreach('csv/memo.csv') do |f|
        unless f[0].nil? || (f[0] == 'id')
          if i == 0
            CSV.open('csv/data.csv', 'w', headers: true) do |test|
              test << %w[id title body]
            end
            CSV.open('csv/data.csv', 'a', headers: true) do |test|
              f[0] = (i += 1).to_s
              test << f
            end
          else
            f[0] = (i += 1).to_s
            CSV.open('csv/data.csv', 'a', headers: true) do |test|
              test << f
            end
          end
        end
      end

      CSV.open('csv/memo.csv', 'w', headers: true) do |test|
        test << %w[id title body]
      end
      t = 0
      CSV.foreach('csv/data.csv') do |f|
        unless f[0].nil? || (f[0] == 'id')
          if t == 0
            CSV.open('csv/memo.csv', 'w', headers: true) do |test|
              test << %w[id title body]
            end
            CSV.open('csv/memo.csv', 'a', headers: true) do |test|
              f[0] = (t += 1).to_s
              test << f
            end
          else
            f[0] = (t += 1).to_s
            CSV.open('csv/memo.csv', 'a', headers: true) do |test|
              test << f
            end
          end
        end
      end
    end

    def delete(id)
      @table.by_row
      @table.delete_if { |f| f[:id] == id.to_i }
      CSV.open('csv/memo.csv', 'w', headers: true) do |csv|
        @table.each do |row|
          csv.puts row
        end
      end
    end

    def update(id, title, body)
      id = id.to_i
      @table = CSV.table('csv/memo.csv', headers: %w[id title body])
      @table.each do |f|
        if f[:id] == id
          f[1] = title
          f[2] = body
        end
      end
      CSV.open('csv/memo.csv', 'w', headers: true) do |csv|
        @table.each do |row|
          csv.puts row
        end
      end
    end
  end
end
