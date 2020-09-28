class CreateTestTables < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.text       :title
      t.timestamps
    end
    create_table :groups do |t|
      t.references :organization
      t.references :manager
      t.text       :title
      t.timestamps
    end
    create_table :users do |t|
      t.references :group
      t.text       :title
      t.timestamps
    end
    create_table :user_configs do |t|
      t.references :user
      t.text       :title
      t.timestamps
    end
    create_table :managers do |t|
      t.references :supervisor
      t.text       :title
      t.timestamps
    end
    create_table :supervisors do |t|
      t.text       :title
      t.timestamps
    end

    create_table :polymorphisms do |t|
      t.references :record, polymorphic: true, index: false
      t.text       :title
      t.timestamps
    end
    create_table :polymorphism_empties do |t|
      t.references :record, polymorphic: true, index: false
      t.text       :title
      t.timestamps
    end
    create_table :polymorphism_isolations do |t|
      t.text       :title
      t.timestamps
    end

    create_table :custom_key_has_manies do |t|
      t.text       :title
      t.timestamps
    end
    create_table :custom_key_has_ones do |t|
      t.text       :title
      t.timestamps
    end
    create_table :custom_key_belongs_tos do |t|
      t.text       :title
      t.timestamps
    end
  end
end
