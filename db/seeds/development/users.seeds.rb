FactoryGirl.create_list(:user, 5)
if User.where(admin: true).empty?
  FactoryGirl.create(:user, :admin)
end
