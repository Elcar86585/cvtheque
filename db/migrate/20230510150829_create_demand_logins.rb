class CreateDemandLogins < ActiveRecord::Migration[7.0]
  def change
    create_table :demand_logins do |t|
      t.string :name
      t.string :email
      t.string :object
      t.string :numero
      t.text :description
      t.boolean :lu, default: false

      t.timestamps
    end
  end
end
