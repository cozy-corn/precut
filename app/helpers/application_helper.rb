module ApplicationHelper
  def qrcode
    qrcode = RQRCode::QRCode.new("https://github.com/")
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
