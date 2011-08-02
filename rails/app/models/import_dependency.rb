class ImportDependency < ActiveRecord::Base
  belongs_to :importing_user, :class_name => "User"
  belongs_to :from_user, :class_name => "User"
end
