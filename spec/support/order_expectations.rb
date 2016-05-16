module OrderExpectations
  def expect_to_appear_in_order(strings)
    regex = /#{strings.join(".*")}/m
    expect(page.body).to match(regex)
  end
end
