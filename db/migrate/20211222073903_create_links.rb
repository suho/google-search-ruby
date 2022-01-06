class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.citext :url, null: false
      t.integer :link_type, null: false
      t.references :keyword, null: false, foreign_key: true

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
