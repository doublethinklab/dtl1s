# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.uuid :uid
      t.string :pid
      t.string :ptitle
      t.string :ptype
      t.string :pdescription
      t.string :ptime
      t.string :mtime
      t.string :url
      t.string :platform
      t.string :score
      t.timestamps
    end

    add_index :pages, :uid
    add_index :pages, :uname
    add_index :pages, :pid
    add_index :pages, :ptitle
    add_index :pages, :ptype
    add_index :pages, :ptime
    add_index :pages, :mtime
    add_index :pages, :url
    add_index :pages, :platform
    add_index :pages, :score
  end
end
