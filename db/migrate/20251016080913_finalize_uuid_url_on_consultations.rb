class FinalizeUuidUrlOnConsultations < ActiveRecord::Migration[7.2]
  def change
    # 1. 新しいレコードが作られた時に自動でUUIDをセットするように設定
    #    PostgreSQLの関数をデフォルト値として設定（change_column_defaultはこのuuid_urlカラムには、デフォルトでこの値を使いなさいというルールをDBに伝える）
    #    { 'gen_random_uuid()' } は、PostgreSQLのgen_random_uuid()関数を呼び出すためのPostgreSQL独自の命令
    change_column_default :consultations, :uuid_url, -> { 'gen_random_uuid()' }

    # 2. 空を許可しない (NOT NULL) 設定に変更
    #    既存の全レコードが更新されているため、安全に変更可能
    change_column_null :consultations, :uuid_url, false
  end
end
