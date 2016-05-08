class PaginatedRelation
  DEFAULT_PER_PAGE = 20

  pattr_initialize :relation, [:per_page!]

  def page(count)
    Page.new(
      relation.offset(per_page * (count - 1)).limit(per_page),
      page: count,
      number_of_pages: relation.count.fdiv(per_page).ceil,
    )
  end

  class Page < SimpleDelegator
    def initialize(relation, page:, number_of_pages:)
      super(relation)
      @page = page
      @number_of_pages = number_of_pages
    end

    attr_reader :number_of_pages

    def current_page
      page
    end

    def previous_page
      page - 1
    end

    def next_page
      page + 1
    end

    def more_pages?
      page < number_of_pages
    end

    def more_previous_pages?
      page > 1
    end

    private

    attr_reader :page
  end
end
