// Initialize and add the map ライブラリの読み込み
let map;

async function initMap() {
  // 初期位置 プロフィール設定した都道府県の都道府県庁
  const position = { 
    lat: parseFloat(document.getElementById("initlat").value),
    lng: parseFloat(document.getElementById("initlng").value)
  };

  // Mapライブラリの呼び出し
  const { Map } = await google.maps.importLibrary("maps");
  // Markerライブラリの呼び出し
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  // 地図表示
  map = new Map(document.getElementById("map"), {
    zoom: 15,
    center: position, // 地図の初期中心地 center: { lat: x.xx, lng: y.yy }の形式
    mapId: "DEMO_MAP_ID", // マーカー表示に必要
    // mapTypeControl: false // Webcamp版から 地図コントロールUIの表示設定
  });

  // infowindowの宣言
  // forEach文の外で宣言することで1個の変数となり、infowindowが表示された状態で別のinfowindowを作ると古いものが消えるようになる
  let infowindow = new google.maps.InfoWindow();

  // マーカー表示
  try {
    // jbuilderでデータを取得
    const response = await fetch("/map.json");
    if (!response.ok) throw new Error('Network response was not ok');

    const { data: { items } } = await response.json();
    if (!Array.isArray(items)) throw new Error("Items is not an array");

    // マーカー設定 forEachでデータの個数だけ繰り返す
    items.forEach( item => {
      // markerのtitleとcontentStringの内容設定
      const postId = item.postId;
      const title = item.title;
      const postImage = item.postImage;
      const category = item.category;
      const prefecture = item.prefecture;
      const month = item.month;
      const body = item.body;
      const userId = item.user.id;
      const userImage = item.user.image;
      const userName = item.user.name;

      const marker = new google.maps.marker.AdvancedMarkerElement ({
        position: { lat: item.latitude, lng: item.longitude },
        map,
        title: title // マウスカーソルが上にあるときに表示するテキスト
        // content: a, // マーカーの外観を変更
        // collisionBehavior: 'REQUIRED', // マーカーが重なっているときの処理
        // gmpDraggable: false, // マーカーのドラッグ可否
      });

      // マーカーにクリックイベントリスナーを追加
      marker.addListener("click", () => {
        // infowindowに表示する内容の設定
        const contentString = `
          <div class="information container p-0">
            <img src="${postImage}"><br />
            <a href="posts/${postId}">${title}</a><br />
            カテゴリ：${category}<br />
            月：${month}<br />
            本文：${body}<br />
            <a href="users/${userId}">
              <img src="${userImage}"> ${userName}
            </a>
          </div>
        `;
        // infowindowにcontentStringを代入
        infowindow.setContent(contentString);
        // infowindowを表示
        infowindow.open({
        anchor: marker,
        map
        })
      });
    });
  } catch (error) {
    console.error('Error fetching or processing post images:', error);
  }
}

initMap();
