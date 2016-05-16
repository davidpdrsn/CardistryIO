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

  it "knows which page it is on" do
    6.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 3)
    page = relation.page(3)

    expect(page.current_page).to eq 3
  end

  it "knows which page is the previous" do
    6.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 3)
    page = relation.page(3)

    expect(page.previous_page).to eq 2
  end

  it "knows which page is the next" do
    6.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 3)
    page = relation.page(3)

    expect(page.next_page).to eq 4
  end

  it "knows if there are more pages" do
    6.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 4)

    expect(relation.page(1).more_pages?).to eq true
    expect(relation.page(2).more_pages?).to eq false
    expect(relation.page(10).more_pages?).to eq false
  end

  it "knows if there are more previous pages" do
    6.times do
      create :user
    end

    relation = PaginatedRelation.new(User.all, per_page: 4)

    expect(relation.page(-10).more_previous_pages?).to eq false
    expect(relation.page(1).more_previous_pages?).to eq false
    expect(relation.page(2).more_previous_pages?).to eq true
  end

  it "enumerates the elements on the page" do
    6.times { create :user }

    page = PaginatedRelation.new(User.all, per_page: 3).page(1)
    mapped_page = page.map { |user| user }

    expect(mapped_page.more_pages?).to eq true
  end
end
