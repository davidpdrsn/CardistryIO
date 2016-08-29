module MoveSortFilterHelper
  def moves_filter_select(form)
    current_filter_params = params.fetch(:filter, {}).fetch(:type, "all")
    filter_options = options_for_select(
      [
        ["Show all", "all"],
        ["Show only finished", "finished"],
        ["Show only ideas", "idea"],
      ],
      current_filter_params,
    )

    form.select(
      :type,
      filter_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  def moves_sort_by_select(form)
    current_sort_by_options = params.fetch(:sort, {}).fetch(:by, "created_at")
    sort_by_options = options_for_select(
      [
        ["Sort by date", "created_at"],
        ["Sort by rating", "rating"],
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

  def moves_sort_direction_select(form)
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
