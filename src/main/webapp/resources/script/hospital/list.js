function trSelectHandler(event) {
    const tr = event.currentTarget
    const id = tr.querySelector('td').innerText
// 		console.log(id)
    location.href = cpath + '/hospital/' + id
}

async function listHandler() {
    const url = cpath + '/hospitals'
    const hospitalList = await fetch(url).then(resp => resp.json())
// 		console.log(hospitalList)

    const tbody = document.querySelector('tbody')
    hospitalList.forEach(hospital => {
        let tag = '<tr>'
        tag += '<td>' + hospital.id + '</td>'
        tag += '<td>' + hospital.hospital_name + '</td>'
        tag += '<td>' + hospital.address + '</td>'
        tag += '</tr>'
        tbody.innerHTML += tag
    })
    tbody.querySelectorAll('tr').forEach(tr => tr.onclick = trSelectHandler)
}