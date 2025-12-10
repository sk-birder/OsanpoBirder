module Public::ReportsHelper
  def report_icon(checked)
    checked ? '<i class="fa-regular fa-square-check"></i>'.html_safe : '<i class="fa-regular fa-square"></i>'.html_safe
  end
end
