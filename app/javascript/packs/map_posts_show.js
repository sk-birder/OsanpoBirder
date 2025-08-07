// ブートストラップ ローダ id="map"で地図を呼び出せるようにする？
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

// Initialize and add the map ライブラリの読み込み
let map;

async function initMap() {
  // 初期位置 投稿から取得するのでCO
  const position = { lat: 35.681236, lng: 139.767125 };

  // Mapライブラリの呼び出し
  const { Map } = await google.maps.importLibrary("maps");
  // Markerライブラリの呼び出し
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  // 地図表示
  map = new Map(document.getElementById("map"), {
    zoom: 15,
    center: position, // 地図の初期中心地 center: { lat: x.xx, lng: y.yy }の形式 投稿から取得する
    mapId: "DEMO_MAP_ID", // マーカー表示に必要
    // mapTypeControl: false // Webcamp版から 地図コントロールUIの表示設定
  });
  
  try {
    // 投稿データを取得 出来なければエラーメッセージを返す
    const response = await fetch(`/posts/${id}.json`);
    if (!response.ok) throw new Error('Network response was not ok');

    const { data: { items } } = await response.json();
    if (!Array.isArray(items)) throw new Error("Items is not an array");

    // itemの数だけ繰り返し 元はindex用なので
    items.forEach( item => {
      // 表示データをここに指定 番号を振れるといいかも
      // const title = item.title;
      // const body = item.body;
      const latitude = item.latitude;
      const longitude = item.longitude;

      // マーカー表示
      const marker = new google.maps.marker.AdvancedMarkerElement ({
        position: { lat: latitude, lng: longitude },
        map,
        // title: shopName,
        // 他の任意のオプションもここに追加可能
      });

      // マーカーをクリックしたときに表示する内容を記述
      const contentString = `
        <div class="information container p-0">
          <div>
            番号を表示する場所
          </div>
        </div>
      `;

      // 下のクリックイベントで呼び出すinfowindowの設定
      const infowindow = new google.maps.InfoWindow({
        content: contentString,
        ariaLabel: title,
      });

      // マーカーにクリックイベントを追加
      marker.addListener("click", () => {
          infowindow.open({
          anchor: marker,
          map,
        })
      });

    });
  } catch (error) {
    console.error('Error fetching or processing posts:', error);
  }
}

initMap();
