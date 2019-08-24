class CreateTestTables < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :manager
    end
    create_table :users do |t|
      t.references :group
    end
    create_table :user_configs do |t|
      t.references :user
    end
    create_table :managers do |t|
      t.references :supervisor
    end
    create_table :supervisors do |t|
      t.text :test
    end
    create_table :names do |t|
      t.text       :name
      t.text       :kana
      t.references :data, polymorphic: true, index: false
    end
    create_table :empties do |t|
      t.references :data, polymorphic: true, index: false
    end
  end
end
