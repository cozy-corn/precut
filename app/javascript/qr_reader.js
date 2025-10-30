import { Html5Qrcode } from "html5-qrcode";

document.addEventListener("DOMContentLoaded", () => {
  // ページに reader 要素が存在するか確認
  const readerElement = document.getElementById("reader");
  if (!readerElement) {
    // console.log("QR reader element not found. Not running scanner.");
    return;
  }
  
  const resultElement = document.getElementById("result");
  const errorElement = document.getElementById("error");

  // エラー/結果表示要素がない場合は警告を出して終了
  if (!resultElement || !errorElement) {
    console.error("Result or Error elements missing. Please check scan.html.erb.");
    return;
  }

  // スキャナーインスタンスの初期化
  // HTML要素のIDである "reader" を指定
  const html5QrCodeScanner = new Html5Qrcode("reader");

  // 読み取り成功時の処理
  const onScanSuccess = (decodedText, result) => {
    console.log("読み取った内容:", decodedText);
    
    // スキャンを停止する
    html5QrCodeScanner.stop().then(() => {
      console.log("スキャン停止");
      
      // 結果の表示を更新
      resultElement.innerText = `読み取り成功: ${decodedText}`;
      resultElement.classList.remove('hidden', 'bg-red-100', 'text-red-800');
      resultElement.classList.add('bg-green-100', 'text-green-800');
      errorElement.classList.add('hidden');

      // 💡 追加の処理：読み取り完了後、自動でURLにジャンプしたい場合
      // if (decodedText.startsWith("http")) {
      //   window.location.href = decodedText;
      // }

    }).catch(err => {
      console.error("スキャン停止エラー:", err);
    });
  };

  // エラー時（読み取りできなかったフレームごと）の処理
  const onScanFailure = (error) => {
    // 連続して呼ばれるため、ここでは表示更新を行わないことが多い
    // console.log("読み取り失敗フレーム:", error);
  };
  
  // カメラを起動してスキャンを開始
  // モバイルでの背面カメラ優先設定を使用
  Html5Qrcode.getCameras().then(devices => {
    if (devices && devices.length) {
      // 背面カメラ (environment) を優先的に探す
      const backCamera = devices.find(d => d.label.toLowerCase().includes('back') || d.label.toLowerCase().includes('environment'));
      const cameraId = backCamera ? backCamera.id : devices[0].id;

      html5QrCodeScanner.start(
        cameraId, 
        { 
          fps: 10, 
          qrbox: { width: 250, height: 250 }
        },
        onScanSuccess,
        onScanFailure
      )
      .catch(err => {
        console.error("カメラ起動エラー:", err);
        errorElement.innerText = "エラー：カメラの起動に失敗しました。HTTPS環境であることを確認し、ブラウザの設定でカメラへのアクセスを許可してください。";
        errorElement.classList.remove('hidden');
        resultElement.classList.add('hidden');
      });
    } else {
      errorElement.innerText = "エラー：デバイスに利用可能なカメラが見つかりません。";
      errorElement.classList.remove('hidden');
    }
  }).catch(err => {
    console.error("カメラデバイス取得エラー:", err);
    errorElement.innerText = "エラー：カメラデバイスのリストを取得できませんでした。";
    errorElement.classList.remove('hidden');
  });
});

