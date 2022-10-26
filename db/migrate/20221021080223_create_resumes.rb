class CreateResumes < ActiveRecord::Migration[6.1]
  def change
    create_table :resumes do |t|
      t.string :name
      t.string :static_data
      t.string :dynamic_data

      t.timestamps
    end
  end
end
