namespace :uuid do
    # taskの説明
    desc "既存のConsultationレコードにUUIDを割り当てる"
    # task_nameはassign_url_uuids、環境変数を読み込むために:environmentを指定
    task assign_url_uuids: :environment do
      puts "UUIDの一括割り当てを開始します"

      # 1. uuid_urlがNULLのレコードをすべて取得
      consultations_to_update = Consultation.where(uuid_url: nil)

      # 2. 処理数を表示
      puts "対象レコード数: #{consultations_to_update.count}"

      # 3. 取得したレコードを一つずつ更新
      consultations_to_update.find_each do |consultation|
        # gen_random_uuid() をデータベースに直接実行させ、UUIDを効率的に生成・保存
        # update_columnsを使うと、バリデーション（検証）やコールバック（フック）をスキップして高速に更新できるrailsのメソッド
        # Consultation.connection.select_value("SELECT gen_random_uuid()") は、PostgreSQLのgen_random_uuid()関数を直接呼び出して新しいUUIDを生成し、その値を取得する
        consultation.update_columns(uuid_url: Consultation.connection.select_value("SELECT gen_random_uuid()"))
        print "." # 進行状況を示すドットを表示
      end
      # \nは改行の意味
      puts "\nUUIDの一括割り当てが完了しました。"
    end
  end
