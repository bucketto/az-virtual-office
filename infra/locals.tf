locals {
  session_hosts_count = (
    var.total_users % 2 == 0
      ? var.total_users / 2
      : (floor(var.total_users / 2) + 1)
  )
}