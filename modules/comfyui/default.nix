{ config, lib, pkgs, ... }:

let
  sdui-improved = pkgs.writeText "sdui-improved.html" ''
    <!DOCTYPE html>
    <html>
    <head><title>SD Gen</title>
    <style>
      body{ background:#111;color:#eee;font-family:system-ui;margin:20px;display:flex;gap:20px;height:100vh;box-sizing:border-box }
      .panel{ background:#1a1a2e;border-radius:12px;padding:16px;display:flex;flex-direction:column;gap:8px }
      .sidebar{ width:340px;flex-shrink:0 }
      .main{ flex:1;display:flex;flex-direction:column }
      #gallery{ flex:1;display:grid;grid-template-columns:repeat(auto-fill,minmax(256px,1fr));gap:12px;overflow-y:auto;padding:4px }
      #gallery img{ width:100%;border-radius:8px;cursor:pointer }
      label{ font-size:12px;color:#888;margin-bottom:-4px }
      input,select,textarea{ background:#16213e;border:1px solid #333;border-radius:6px;color:#eee;padding:6px 8px }
      textarea{ resize:vertical;min-height:60px;font-family:monospace }
      input[type=number]{ width:70px }
      .row{ display:flex;gap:8px;align-items:center }
      button{ background:#e94560;color:white;border:none;border-radius:6px;padding:8px 16px;cursor:pointer;font-weight:bold }
      button:hover{ background:#ff6b81 }
      .active-img{ max-width:100%;max-height:70vh;border-radius:8px }
      #preview{ display:none;flex-direction:column;align-items:center;gap:12px }
      .seed-row{ display:flex;gap:8px }
      #progress{ display:none;text-align:center;padding:20px }
      .spinner{ border:3px solid #333;border-top:3px solid #e94560;border-radius:50%;width:24px;height:24px;animation:spin 1s linear infinite;margin:0 auto 8px }
      @keyframes spin{ to{transform:rotate(360deg)} }
    </style>
    </head>
    <body>
    <div class="sidebar panel">
      <h2>SD Generation</h2>
      <label>Prompt</label><textarea id="prompt" rows=3></textarea>
      <label>Negative Prompt</label><textarea id="neg" rows=2></textarea>
      <div class="row"><label>Width</label><input type=number id="w" value=832 min=256 max=2048 step=64>
      <label>Height</label><input type=number id="h" value=1216 min=256 max=2048 step=64></div>
      <div class="row"><label>Steps</label><input type=number id="steps" value=25 min=1 max=100>
      <label>CFG</label><input type=number id="cfg" value=4 min=1 max=30 step=0.5></div>
      <label>Sampler</label>
      <select id="sampler">
        <option>Euler</option><option>Euler a</option><option>DPM++ 2M Karras</option>
        <option>DPM++ 2S a Karras</option><option selected>DPM++ 2M SDE Karras</option>
        <option>DDIM</option><option>LCM</option>
      </select>
      <div class="seed-row"><label>Seed (-1 = random)</label><input type=number id="seed" value=-1 style="flex:1"></div>
      <button id="genBtn">Generate</button>
      <div id="progress"><div class="spinner"></div><span id="progText">Generating...</span></div>
    </div>
    <div class="main">
      <div id="gallery"></div>
      <div id="preview"><img class="active-img" id="activeImg"><button id="closePreview">Back</button></div>
    </div>
    <script>
      const API = '/sdapi/v1/txt2img';
      function img2b64(data){const chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';let res='';const bytes=new Uint8Array(data);for(let i=0;i<bytes.length;i+=3){res+=chars[bytes[i]>>2];if(i+1<bytes.length){res+=chars[((bytes[i]&3)<<4)|(bytes[i+1]>>4)];if(i+2<bytes.length){res+=chars[((bytes[i+1]&15)<<2)|(bytes[i+2]>>6)];res+=chars[bytes[i+2]&63]}else{res+=chars[(bytes[i+1]&15)<<2];res+='='}}else{res+=chars[(bytes[i]&3)<<4];res+='=='}}return res}

      async function generate(){
        const btn=document.getElementById('genBtn');const prog=document.getElementById('progress');
        btn.disabled=true;prog.style.display='block';
        try{
          const r=await fetch(API,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({
            prompt:document.getElementById('prompt').value,
            negative_prompt:document.getElementById('neg').value,
            width:+document.getElementById('w').value,
            height:+document.getElementById('h').value,
            steps:+document.getElementById('steps').value,
            cfg_scale:+document.getElementById('cfg').value,
            sampler_name:document.getElementById('sampler').value,
            seed:+document.getElementById('seed').value,
            batch_size:1
          })});
          const j=await r.json();
          const gallery=document.getElementById('gallery');
          j.images.forEach(img=>{
            const el=document.createElement('img');
            el.src='data:image/png;base64,'+img;
            el.onclick=function(){document.getElementById('preview').style.display='flex';document.getElementById('gallery').style.display='none';document.getElementById('activeImg').src=this.src};
            gallery.prepend(el);
          });
        }catch(e){alert('Error: '+e.message)}
        finally{btn.disabled=false;prog.style.display='none'}
      }
      document.getElementById('genBtn').onclick=generate;
      document.getElementById('closePreview').onclick=function(){
        document.getElementById('preview').style.display='none';document.getElementById('gallery').style.display='grid'
      };
      document.getElementById('activeImg').onclick=function(){
        const a=document.createElement('a');a.href=this.src;a.download='generated.png';a.click()
      };
      document.getElementById('prompt').value='masterpiece, best quality, 1girl, cute, smile';
      document.getElementById('neg').value='low quality, worst quality, bad anatomy, bad hands';
    </script>
    </body>
    </html>
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 8188 ];
}
