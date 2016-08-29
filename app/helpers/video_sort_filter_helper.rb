module VideoSortFilterHelper
  def videos_filter_select(form)
    current_filter_params = params.fetch(:filter, {}).fetch(:type, "all")
    filter_options = options_for_select(Video.types_for_filtering, current_filter_params)

    form.select(
      :type,
      filter_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  def videos_sort_by_select(form)
    current_sort_by_options = params.fetch(:sort, {}).fetch(:by, "created_at")
    sort_by_options = options_for_select(
      [
        ["Sort by date", "created_at"],
        ["Sort by rating", "rating"],
        ["Sort by views", "views_count"],
      ],
      current_sort_by_options,
    )

    form.select(
      :by,
      sort_by_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  def videos_sort_direction_select(form)
    current_sort_direction_options = params.fetch(:sort, {}).fetch(:direction, "DESC")
    sort_direction_options = options_for_select(
      [
        ["Descending", "DESC"],
        ["Ascending", "ASC"]
      ],
      current_sort_direction_options,
    )

    form.select(
      :direction,
      sort_direction_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end
end
