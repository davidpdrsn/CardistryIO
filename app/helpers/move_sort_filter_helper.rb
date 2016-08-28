# TODO: Fix duplication between this module and video related module
# TODO: Don't require prefixing methods with move_
module MoveSortFilterHelper
  def moves_filter_select(form)
    form.select(
      :type,
      moves_filter_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  def moves_sort_by_select(form)
    form.select(
      :by,
      moves_sort_by_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  def moves_sort_direction_select(form)
    form.select(
      :direction,
      moves_sort_direction_options,
      {},
      { class: "select", onchange: "this.form.submit()" },
    )
  end

  private

  def moves_current_filter_params
    params.fetch(:filter, {}).fetch(:type, "all")
  end

  def moves_filter_options
    options_for_select(
      [
        ["Show all", "all"],
        ["Show only finished", "finished"],
        ["Show only ideas", "idea"],
      ],
      moves_current_filter_params,
    )
  end

  def moves_current_sort_by_options
    params.fetch(:sort, {}).fetch(:by, "created_at")
  end

  def moves_sort_by_options
    options_for_select(
      [
        ["Sort by date", "created_at"],
        ["Sort by rating", "rating"],
      ],
      moves_current_sort_by_options,
    )
  end

  # DUP: laksjdlk
  def moves_sort_direction_options
    options_for_select(
      [
        ["Descending", "DESC"],
        ["Ascending", "ASC"]
      ],
      moves_current_sort_direction_options,
    )
  end

  # DUP: laksjdlk2
  def moves_current_sort_direction_options
    params.fetch(:sort, {}).fetch(:direction, "DESC")
  end
end
