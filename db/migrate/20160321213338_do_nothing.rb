# This migration intentionally does nothing
# Was just added to trigger migrations to be run on production server
class DoNothing < ActiveRecord::Migration
  def change
  end
end
