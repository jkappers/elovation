class RemoveNullConstraintOnRatings < ActiveRecord::Migration
  def up
    change_column :ratings, :player_id, :integer, :null => true
  end
  
  def down
    change_column :ratings, :player_id, :integer, :null => false
  end
end
