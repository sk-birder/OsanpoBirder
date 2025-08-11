// 変数宣言
let map;
let marker;

async function initMap() {
  // マーカー座標
  const position = { 
    lat: parseFloat(document.getElementById("lat").value),
    lng: parseFloat(document.getElementById("lng").value)
  };

  // Mapライブラリの呼び出し
  const { Map } = await google.maps.importLibrary("maps");
  // Markerライブラリの呼び出し
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  // 地図表示
  map = new Map(document.getElementById("map"), {
    zoom: 15,
    center: position, // マーカーの座標を中心とする
    mapId: "DEMO_MAP_ID", // マーカー表示に必要
    // mapTypeControl: false // 地図コントロールUIの表示設定
  });

  // 投稿に登録された座標にマーカー設置
  marker = new AdvancedMarkerElement({
    map: map,
    position: position
  });
}

// 以下は可能ならば実装
// // 複数マーカーを保存する配列を作成
// let markers = []; 

initMap();
