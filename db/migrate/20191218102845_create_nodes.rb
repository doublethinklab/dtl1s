class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes, id: :uuid do |t|
      t.string :name
      t.string :source
      t.string :url
      t.jsonb :archive, null: false, default: '{}'
      
      t.timestamps
    end
  end
end
