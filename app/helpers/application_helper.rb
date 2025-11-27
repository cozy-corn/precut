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

  def default_meta_tags
    {
      site: "precut",
      title: "来店前になりたいを共有できる美容室のための事前カウンセリングアプリ",
      reverse: true,
      charset: "utf-8",
      separator: "|",
      description: "美容室での施術前カウンセリングを効率化し、お客様と美容師が「なりたい」を事前に共有することができます。",
      keywords: "美容室,カウンセリング,事前共有,美容師,ヘアスタイル,カルテ,予約,新規",
      canonical: request.original_url,
      og: {
        title: "MyApp",
        description: "This is the best app ever.",
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@ko____na",
        image: image_url("ogp.png")
      }
    }
  end
end
