module ApplicationHelper
  def qrcode(url_to_share)
    qrcode = RQRCode::QRCode.new(url_to_share)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
