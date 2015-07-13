module NotificationSubjectLinkHelper
  def notification_text(notification)
    options = {
      link: ->() {
        notification_subject_link(notification)
      },
    }
    text = notification
      .text
      .expand(options)
      .html_safe

    link_mentions(text)
  end

  def notification_subject_link(notification)
    link_to(
      notification.subject.class.name.downcase,
      notification.subject_for_link
    )
  end
end
