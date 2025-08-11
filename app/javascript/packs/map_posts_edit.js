// 変数宣言
let map;
let marker;

async function initMap() {
  // 初期位置 元の投稿データから取得する
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
    center: position, // 地図の初期中心地
    mapId: "DEMO_MAP_ID", // マーカー表示に必要
    // mapTypeControl: false // 地図コントロールUIの表示設定
  });

  // 投稿に登録された座標にマーカー設置
  marker = new AdvancedMarkerElement({
    map: map,
    position: position
  });
  
  // クリックイベント用のgeocoderの宣言
  let geocoder = new google.maps.Geocoder();

  // クリックイベントリスナーの設定
  map.addListener('click', function(e) {
    getClickLatLng(e.latLng, map);
  });
  
  // クリックイベントの内容設定
  function getClickLatLng(lat_lng, map) {
    // クリックした位置の座標をViewに渡す
    document.getElementById('lat').value = lat_lng.lat();
    document.getElementById('lng').value = lat_lng.lng();
    
    // マーカーの削除
    marker.setMap(null);
    marker = null;

    // マーカー設置
    marker = new AdvancedMarkerElement({
      map: map,
      position: lat_lng
    });

    // クリックした位置を地図の中心にする
    map.panTo(lat_lng);

    // 逆ジオコーディング エリアを設定する
    geocoder.geocode({ 'location': lat_lng }, function(results, status) {
      if (status === 'OK' && results.length > 0) {
        if (results[0]) {
          // 都道府県情報を取得してセレクトボックスにセットする処理を記述
          let prefecture = extractPrefectureFromResults(results);
          setPrefectureToSelectBox(prefecture);
        } else {
          console.log('Geocoder failed due to: ' + status);
        }
      } else {
        console.log('Geocode was not successful for the following reason: ' + status);
      }
    });

    function extractPrefectureFromResults(results) {
      for (let i = 0; i < results[0].address_components.length; i++) {
        if (results[0].address_components[i].types[0] === 'administrative_area_level_1') {
          return results[0].address_components[i].long_name;
        }
      }
      return 'Unknown';
    }
    
    function setPrefectureToSelectBox(prefecture) {
      // 都道府県をセレクトボックスにセットする処理を記述
      document.getElementById('post_prefecture').value = prefecture;
    }
  }
}

// 以下は可能ならば実装
// // 複数マーカーを保存する配列を作成
// let markers = []; 

// // マーカーを追加する関数 上限数を設けたいところ(10個程度) 更にマーカーの座標を取得したい
// function addMarker(location) {
//   const marker = new google.maps.Marker({
//     position: location,
//     map: map,
//   });
//   markers.push(marker); // マーカーを配列に追加

  // (任意) マーカーに吹き出しを追加
  // const infowindow = new google.maps.InfoWindow({
  //   content: `緯度: ${location.lat()}, 経度: ${location.lng()}`
  // });
  // marker.addListener("click", () => {
  //     infowindow.open(map, marker);
  // });
// }

// // マーカーにクリックイベントを追加 これは情報の表示をするもの
// // 設置したマーカーを削除できるようにしたい
// marker.addListener("click", () => {
//     infowindow.open({
//     anchor: marker,
//     map,
//   })
// });

initMap();
