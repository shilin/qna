class AddBestColumnToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :best, :boolean, default: false
    add_index :answers, :best
  end
end
