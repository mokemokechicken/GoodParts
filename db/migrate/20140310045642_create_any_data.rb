class CreateAnyData < ActiveRecord::Migration
  def change
    create_table :any_data do |t|
      t.string :key
      t.binary :data

      t.timestamps
    end
  end
end
