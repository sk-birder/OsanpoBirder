// ブートストラップ ローダ id="map"で地図を呼び出せるようにする？
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

// Initialize and add the map ライブラリの読み込み
let map;

async function initMap() {
  // 初期位置用の定数宣言 constなので書き換えられない 東京駅に設定済み
  // webcamp版には無い 投稿から取得するときはconstだと困るかも
  const position = { lat: 35.681236, lng: 139.767125 };

  // Mapライブラリの呼び出し
  const { Map } = await google.maps.importLibrary("maps");
  // Markerライブラリの呼び出し
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
}

initMap();
