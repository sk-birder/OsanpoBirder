// ブートストラップローダ
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

// 変数宣言
let map;
let marker;

async function initMap() {
  // post_paramsにlatitudeとlongitudeがあればStringの"true"を返す
  // バリデーションエラー時にマーカーを失わないようにするための設定
  const hasLatLngAlreadyString = document.getElementById("hasLatLngAlready").value;
  // hasLatLngAlreadyStringをboolean型に変換
  const hasLatLngAlready = (hasLatLngAlreadyString == "true");

  // 地図の中心用の変数
  let position;

  // 地図の初期位置
  if(hasLatLngAlready){
    // マーカーを立てた状態でバリデーションエラーを起こした場合
    // そのマーカーの位置
    position = { 
      lat: parseFloat(document.getElementById("lat").value),
      lng: parseFloat(document.getElementById("lng").value)
    };
  } else {
    // 新規投稿の通常表示と、マーカーがない状態でバリデーションエラーを起こした場合
    // プロフィール設定の都道府県の都道府県庁
    position = { 
      lat: parseFloat(document.getElementById("initlat").value),
      lng: parseFloat(document.getElementById("initlng").value)
    };
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

  // バリデーションエラー時のマーカー設置
  if(hasLatLngAlready){
    marker = new AdvancedMarkerElement({
    map: map,
    position: position
    });
  };
  
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
    
    // マーカーが既にあれば削除
    if(marker != null){
		    marker.setMap(null);
        marker = null;
    }

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
