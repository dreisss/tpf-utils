$main = "$(pwd)".Split("\")[-1].Split("-")[0]

function createLink {
    param($element)

    $url = [uri]::EscapeDataString($main + "-_" + $element)

    $headers = @(
        'App-Code:proof'
        'Authorization:M2JiMjAxZjktOWE1Ni00YWVhLWI4MGMtZjZiZDI5OWQzYjk2fDE3MTkzNDQyMjI='
        'Cookie:_gac_UA-63230122-4=1.1719255529.EAIaIQobChMIsdug9_X0hgMVCxitBh2-Fw3UEAAYASABEgKYdPD_BwE; _gcl_au=1.1.1534014804.1719255529; _ga_BNZDTDMGM4=GS1.2.1719255528.1.0.1719255528.0.0.0; _hjSessionUser_2827382=eyJpZCI6ImQwYzlhYzkzLWQwMjQtNTM3OC05MmZiLThiYzQwODU2YmFkZSIsImNyZWF0ZWQiOjE3MTkyNTU1MjkwNTAsImV4aXN0aW5nIjpmYWxzZX0=; FPID=FPID2.2.UEedp%2Fd7TpylBfhsjYtERzyMW7n2YAKTTfNHOts3exo%3D.1719255529; _fbp=fb.1.1719255529518.615271305550016330; _tt_enable_cookie=1; _ttp=st3iCBxCP8BhvgWCoMRGtinhLPR; utm_source=d3d3Lmdvb2dsZS5jb20+Z29vZ2xlX2Fkcw==; utm_medium=Y3Bj; utm_campaign=aW5zdGl0dWNpb25hbF9zZWFyY2g=; _gcl_aw=GCL.1719255556.EAIaIQobChMIsdug9_X0hgMVCxitBh2-Fw3UEAAYASAAEgLVBPD_BwE; _gcl_gs=2.1.k1$i1719255553; _gac_UA-142142134-1=1.1719255556.EAIaIQobChMIsdug9_X0hgMVCxitBh2-Fw3UEAAYASAAEgLVBPD_BwE; __zlcmid=1MQmoqRUhBezcZk; _ga_XNT2YZFE96=GS1.1.1720703939.2.0.1720703946.0.0.1478601448; _ga=GA1.2.779028660.1719255529; _gid=GA1.2.99732105.1721484919; _gat_UA-142142134-1=1; _ga_RWJEP4EFWP=GS1.2.1721486879.7.1.1721488096.42.0.0'
    )

    $request = echo @"
    {"collection":{
        "name":"$main - $element",
        "photographed_at":null,
        "message":"Bem-vindo(a) ao sistema de visualização e aprovação de fotos.",
        "download_photo_option_value":"DOWNLOAD_ALL",
        "downloadable":true,
        "single_download":true,
        "commentable":true,
        "shareable":false,
        "selection_limit":null,
        "category_id":124404,
        "exhibition_size_id":5,
        "selection_limit_date":null,
        "selection_limit_additional":null,
        "selection_limit_additional_value":null,
        "currency":null,
        "watermark_enabled":false,
        "friendly_url":"$url",
        "reminder_kind":"NONE",
        "collection_sell_attributes":{"buy_from":0,
        "disabled":true},
        "selection_min":null,
        "selection_quantity_type":"unlimited"
    }}
"@ | https --verify no POST "https://proof-api.alboompro.com/api/collections" $headers

    if (($request | jq '.success') -ne "true") {
        echo "-------------------------> Erro <----------------------"
        $request
        exit 1
    }

    $id = $request | jq '.collection.id'
    
    start chrome "https://proof.alboompro.com/selection/images/$id"
}

$folders = Read-Host "Quantidade de pastas"

ls | select -first $folders | % { createLink($_.Name) }

# TODO: auto image upload
