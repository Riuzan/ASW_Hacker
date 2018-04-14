class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :votes, :default => 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
