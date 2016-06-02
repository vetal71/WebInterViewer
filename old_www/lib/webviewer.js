$(function () {
    $("#contacts").jqGrid({
        url: "/getcontact",
        datatype: 'json',
        mtype: 'Get',
        colNames: ['Код', 'Фамилия,имя,отчество', 'Пол', 'Дом.телефон', 'Моб.телефон', 'EMail'],
        colModel: [
            { key: true, hidden: true, name: 'code', index: 'code', editable: true },
            { key: false, name: 'fio', index: 'fio', editable: true },
            { key: false, name: 'sex', index: 'sex', editable: true, edittype: 'select', editoptions: { value: { 'мужской': 'мужской', 'женский': 'женский' } } },
            { key: false, name: 'homephone', index: 'homephone', editable: true },
            { key: false, name: 'celurarphone', index: 'celurarphone', editable: true },
            { key: false, name: 'email', index: 'email', editable: true }],
        pager: jQuery('#pager'),
        rowNum: 10,
        rowList: [10, 20, 30, 40],
        height: '100%',
        viewrecords: true,
        caption: 'База интервьюеров',
        emptyrecords: 'Нет данных для отображения',
        jsonReader: {
            root: "rows",
            page: "page",
            total: "total",
            records: "records",
            repeatitems: false,
            Id: "0"
        },
        autowidth: true,
        multiselect: false
    }).navGrid('#pager', { edit: true, add: true, del: true, search: true, refresh: true },
        {
            // edit options
            zIndex: 100,
            url: '/savecontact',
            closeOnEscape: true,
            closeAfterEdit: true,
            recreateForm: true,
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        },
        {
            // add options
            zIndex: 100,
            url: "/savecontact",
            closeOnEscape: true,
            closeAfterAdd: true,
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        },
        {
            // delete options
            zIndex: 100,
            url: "/deletecontact",
            closeOnEscape: true,
            closeAfterDelete: true,
            recreateForm: true,
            msg: "Are you sure you want to delete this task?",
            afterComplete: function (response) {
                if (response.responseText) {
                    alert(response.responseText);
                }
            }
        });
});