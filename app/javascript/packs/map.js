// ブートストラップ ローダ
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

// Initialize and add the map ライブラリの読み込み
let map;
let markers = []; // 複数マーカーの管理 配列？

async function initMap() {
  // 初期位置用の定数宣言 constなので書き換えられない 東京駅に設定済み
  // webcamp版には無い 投稿から取得するときはconstだと困るんじゃないかな
  const position = { lat: 35.681236, lng: 139.767125 };

  // 以下2行はお約束
  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  // 地図表示 新規投稿画面では拠点地設定に即した中心地を設定すると便利かも
  map = new Map(document.getElementById("map"), {
    zoom: 15,
    center: position, // 地図の初期中心地 center: { lat: x.xx, lng: y.yy }の形式
    mapId: "DEMO_MAP_ID", // マーカー表示に必要
    // mapTypeControl: false // Webcamp版から 地図コントロールUIの表示設定
  });

  // マーカー表示
  const marker = new AdvancedMarkerElement({
    map: map,
    position: position, // マーカーの座標 position: { lat: x.xx, lng: y.yy }の形式
    title: "Marker Test",
  });
  
  // クリックイベントリスナー public/posts#new以外では機能しないようにすること
  map.addListener("click", (event) => {
    addMarker(event.latLng);
  });
}

// マーカーを追加する関数 public/posts#new以外では機能しないようにすること
// 上限数を設けたいところ(10個とか)
// 更に、マーカーの座標を取得したい
function addMarker(location) {
  const marker = new google.maps.Marker({
    position: location,
    map: map,
  });
  markers.push(marker); // マーカーを配列に追加

  // (任意) マーカーに吹き出しを追加
  const infowindow = new google.maps.InfoWindow({
    content: `緯度: ${location.lat()}, 経度: ${location.lng()}`
  });
  marker.addListener("click", () => {
      infowindow.open(map, marker);
  });
}

initMap();

// Webcamp版
  // 追記
  // try {
  //   const response = await fetch("/post_images.json");
  //   if (!response.ok) throw new Error('Network response was not ok');

  //   const { data: { items } } = await response.json();
  //   if (!Array.isArray(items)) throw new Error("Items is not an array");

  //   items.forEach( item => {
  //     const latitude = item.latitude;
  //     const longitude = item.longitude;
  //     const shopName = item.shop_name;

  //     const marker = new google.maps.marker.AdvancedMarkerElement ({
  //       position: { lat: latitude, lng: longitude },
  //       map,
  //       title: shopName,
  //       // 他の任意のオプションもここに追加可能
  //     });
  //   });
  // } catch (error) {
  //   console.error('Error fetching or processing post images:', error);
  // }
