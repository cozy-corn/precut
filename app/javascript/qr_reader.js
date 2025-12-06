import { Html5Qrcode } from "html5-qrcode";

// グローバルスコープでスキャナーインスタンスを保持するための変数
let html5QrCodeScanner = null;

// --- 起動処理 ---
document.addEventListener("turbo:load", () => {
  // 1. 既にスキャナーが起動中の場合は何もしない（念のため）
  if (html5QrCodeScanner) {
    console.warn("Scanner already initialized.");
    return;
  }
  
  const readerElement = document.getElementById("reader");
  const resultElement = document.getElementById("result");
  const errorElement = document.getElementById("error");

  if (!readerElement || !resultElement || !errorElement) {
    // スキャンページではない、または要素がない場合は処理を終了
    return;
  }

  // 2. スキャナーインスタンスの初期化
  html5QrCodeScanner = new Html5Qrcode("reader");

  // 読み取り成功時の処理
  const onScanSuccess = (decodedText, result) => {
    console.log("読み取った内容:", decodedText);
    
    // スキャンを停止
    if (html5QrCodeScanner) {
      html5QrCodeScanner.stop().then(() => {
        console.log("スキャン成功後の停止完了");
        // 成功後の表示
        resultElement.innerText = `読み取り成功: ${decodedText}`;
        resultElement.classList.remove('hidden', 'bg-red-100', 'text-red-800');
        resultElement.classList.add('bg-green-100', 'text-green-800');
        errorElement.classList.add('hidden');
        
        // 自動ジャンプ処理 
      if (decodedText.startsWith("http")) {
       window.location.href = decodedText;
         }
      }).catch(err => console.error("スキャン停止エラー:", err));
    }
  };

  const onScanFailure = (error) => {
    // 連続で呼ばれるため、ここでは何もしない
  };
  
  // 3. カメラを起動してスキャンを開始
  Html5Qrcode.getCameras().then(devices => {
    if (devices && devices.length) {

      html5QrCodeScanner.start(
        { facingMode: "environment" },
        { fps: 10, qrbox: { width: 250, height: 250 } },
        onScanSuccess,
        onScanFailure
      )
      .catch(err => {
        console.error("カメラ起動エラー:", err);
        errorElement.innerText = "エラー：カメラの起動に失敗しました。HTTPS環境とカメラ許可を確認してください。";
        errorElement.classList.remove('hidden');
        resultElement.classList.add('hidden');
        html5QrCodeScanner = null; // エラー時もインスタンスをクリア
      });
    } else {
      errorElement.innerText = "エラー：利用可能なカメラが見つかりません。";
      errorElement.classList.remove('hidden');
      html5QrCodeScanner = null; // カメラなし時もインスタンスをクリア
    }
  }).catch(err => {
    console.error("カメラデバイス取得エラー:", err);
    errorElement.innerText = "エラー：カメラデバイスのリストを取得できませんでした。";
    errorElement.classList.remove('hidden');
    html5QrCodeScanner = null; // エラー時もインスタンスをクリア
  });
});


// --- 停止処理（Turbo専用）---
// ユーザーがこのページから他のページへ移動する直前に発火するイベント
document.addEventListener("turbo:before-cache", () => {
  if (html5QrCodeScanner) {
    // カメラがまだ動いている（スキャン成功で停止していない）場合
    html5QrCodeScanner.stop().then(() => {
      console.log("Turbo移動: スキャナーを正常に停止しました。");
      html5QrCodeScanner = null; // インスタンスをクリア
    }).catch(err => {
      // 既に停止している場合などに発生するエラー。無視してOK。
      console.warn("Turbo移動: スキャナー停止中にエラーが発生しましたが、無視します。", err);
      html5QrCodeScanner = null; // インスタンスをクリア
    });
  }
});

