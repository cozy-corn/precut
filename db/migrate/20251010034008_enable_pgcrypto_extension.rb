class EnablePgcryptoExtension < ActiveRecord::Migration[7.2]
  def change
    # PostgreSQLに対して、UUID生成関数(gen_random_uuid)を使えるように指示
    enable_extension 'pgcrypto'
  end
end
