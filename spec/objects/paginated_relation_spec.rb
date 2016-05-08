require "rails_helper"

describe PaginatedRelation do
  it "returns everything if there are few objects" do
    user = create :user

    relation = PaginatedRelation.new(User.all, per_page: 20)

    expect(relation.page(1)).to eq [user]
  end

  it "returns the stuff on the first page" do
    users = 5.times.map do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 20)

    expect(relation.page(1)).to eq users
  end

  it "returns the right number of objects" do
    5.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 2)

    expect(relation.page(1).count).to eq 2
  end

  it "returns the stuff on the other pages" do
    6.times do
      create :user
    end
    user = create :user

    relation = PaginatedRelation.new(User.all, per_page: 3)

    expect(relation.page(3).map(&:username)).to eq [user.username]
  end
end
