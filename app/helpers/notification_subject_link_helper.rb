module NotificationSubjectLinkHelper
  def notification_subject_link(notification)
    link_to(
      notification.subject.class.name.downcase,
      notification.subject_for_link
    )
  end
end
