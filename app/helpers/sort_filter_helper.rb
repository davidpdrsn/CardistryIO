module SortFilterHelper
  def current_filter_sort_params
    {
      filter: {
        type: current_filter_params,
      },
      sort: {
        by: current_sort_by_options,
        direction: current_sort_direction_options,
      }
    }
  end

  def moves_sort_by_select(form)
    options = options_for_select(
      [
        ["Sort by date", "created_at"],
        ["Sort by rating", "rating"],
      ],
      current_sort_by_options,
    )
    make_select(form: form, key: :by, options: options)
  end

  def moves_filter_select(form)
    options = options_for_select(
      [
        ["Show all", "all"],
        ["Show only finished", "finished"],
        ["Show only ideas", "idea"],
      ],
      current_filter_params,
    )
    make_select(form: form, key: :type, options: options)
  end

  def moves_sort_direction_select(form)
    videos_sort_direction_select(form)
  end

  def videos_filter_select(form)
    options = options_for_select(Video.types_for_filtering, current_filter_params)
    make_select(form: form, key: :type, options: options)
  end

  def videos_sort_by_select(form)
    options = options_for_select(
      [
        ["Sort by date", "created_at"],
        ["Sort by rating", "rating"],
        ["Sort by views", "views_count"],
      ],
      current_sort_by_options,
    )
    make_select(form: form, key: :by, options: options)
  end

  def videos_sort_direction_select(form)
    options = options_for_select(
      [
        ["Descending", "DESC"],
        ["Ascending", "ASC"]
      ],
      current_sort_direction_options,
    )
    make_select(form: form, key: :direction, options: options)
  end

  private

  def current_filter_params
    params.fetch(:filter, {}).fetch(:type, "all")
  end

  def current_sort_by_options
    params.fetch(:sort, {}).fetch(:by, "created_at")
  end

  def current_sort_direction_options
    params.fetch(:sort, {}).fetch(:direction, "DESC")
  end

  def make_select(form:, key:, options:)
    form.select(
      key,
      options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end
end
