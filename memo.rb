# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'csv'
require 'slim'

get '/memos' do
  Memo.organize
  @table = CSV.table('csv/memo.csv', headers: %w[id title body])
  slim :top
end

get '/memos/:id/edit' do |id|
  id = id.to_i
  @title = Memo.title(id)
  @body = Memo.body(id)
  @id = id
  slim :edit
end

get '/memos/new' do
  @title = '新規登録'
  @content = 'memo new'
  slim :new
end

get '/memos/:id' do |id|
  @id = id.to_i
  @title = Memo.title(id)
  @body = Memo.body(id)
  slim :show
end

post '/memos' do
  Memo.create(title: params['title'], body: params['body'])
  redirect to('/memos')
end

patch '/memos/:id' do |id|
  Memo.update(id, params['title'], params['body'])
  Memo.organize
  redirect to('/memos')
end

delete '/memos/:id' do |id|
  Memo.delete(id)
  redirect to('/memos')
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
      @table[:body][id]
    end

    def create(title: title, body: body)
      @table = CSV.table('csv/memo.csv', headers: %w[id title body])
      @new_id_num = @table.size
      if @table.first.nil?
        CSV.open('csv/memo.csv', 'w', headers: true) do |file|
          file.flock(File::LOCK_EX)
          file << %w[id title body]
          file << [1, title, body]
        end

      else
        CSV.open('csv/memo.csv', 'a', headers: true) do |file|
          file.flock(File::LOCK_EX)
          file << [@new_id_num, title, body]
        end
      end
    end

    def organize
      @table = CSV.table('csv/memo.csv', headers: %w[id title body])
      CSV.open('csv/memo.csv', 'w', headers: true) do |file|
        file.flock(File::LOCK_EX)
        i = 0
        @table.each do |f|
          reg = Regexp.new(/\d/)
          f[0] = (i += 1) if reg.match((f[0]).to_s)
          next if f[0].nil?

          file.puts f
        end
      end
    end

    def delete(id)
      @table.by_row
      @table.delete_if { |f| f[:id] == id.to_i }
      CSV.open('csv/memo.csv', 'w', headers: true) do |file|
        file.flock(File::LOCK_EX)
        @table.each do |row|
          file.puts row
        end
      end
    end

    def update(id, title, body)
      id = id.to_i

      @table.each do |f|
        if f[:id] == id
          f[1] = title
          f[2] = body
        end
      end
      CSV.open('csv/memo.csv', 'w', headers: true) do |file|
        file.flock(File::LOCK_EX)
        @table.each do |row|
          file.puts row
        end
      end
    end
  end
end
