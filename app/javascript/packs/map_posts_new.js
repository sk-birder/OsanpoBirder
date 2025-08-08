// ブートストラップローダ
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

// 変数宣言
let map;
let marker;

async function initMap() {
  // 初期位置 東京駅
  // 拠点地設定に応じて変えられるとなお良い
  const position = { lat: 35.681236, lng: 139.767125 };

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
      position: lat_lng,
    });

    // クリックした位置を地図の中心にする
    map.panTo(lat_lng);
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
