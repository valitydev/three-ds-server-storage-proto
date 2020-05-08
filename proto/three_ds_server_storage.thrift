namespace java com.rbkmoney.damsel.three_ds_server_storage
namespace erlang three_ds_server_storage

typedef string ThreeDsServerTransactionID
typedef string DirectoryServerProviderID
typedef string Timestamp

/** Карточный диапазон */
struct CardRange {
    1: required i64 range_start
    2: required i64 range_end
}

/** Вспомогательная информация по транзакции */
struct RReqTransactionInfo {
    1: required ThreeDsServerTransactionID transaction_id
    2: required string                     device_channel
    3: required Timestamp                  decoupled_auth_max_time
    4: required string                     acs_dec_con_ind
}

struct UpdateCardRangesRequest {
    1: required DirectoryServerProviderID provider_id
}

struct GetCardRangesRequest {
    1: required DirectoryServerProviderID provider_id
}

struct GetCardRangesResponse {
    1: required DirectoryServerProviderID provider_id
    2: required Timestamp                 last_updated_at
    3: required list<CardRange>           card_ranges
}

service CardRangesStorage {

    /**
     * Требование инициировать обмен проприетарными сообщениями между Storage и 3DS Server,
     * приводящий к обновлению карточных диапазонов в Storage
     *
     * НЕ приводит к обновлению карточных диапазонов в 3DS Server
     */
    void UpdateCardRanges(1: UpdateCardRangesRequest request)

    /** Запрос на получение всех карточных диапазонов */
    GetCardRangesResponse GetCardRanges(1: GetCardRangesRequest request)
}

service RReqTransactionInfoStorage {

    /** Запрос на сохранение информации по транзакции */
    void SaveRReqTransactionInfo(1: RReqTransactionInfo transaction_info)

    /** Запрос на получение информации по транзакции */
    RReqTransactionInfo GetRReqTransactionInfo(1: ThreeDsServerTransactionID transaction_id)
}
