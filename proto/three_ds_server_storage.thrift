namespace java com.rbkmoney.damsel.three_ds_server_storage
namespace erlang three_ds_server_storage

typedef string ThreeDsServerTransactionID
typedef string DirectoryServerProviderID
typedef string Timestamp
typedef string MessageVersion

exception CardRangesNotFound {
    1: string info
}

exception ChallengeFlowTransactionInfoNotFound {
    1: string info
}

/** Карточный диапазон */
struct CardRange {
    1: required i64 range_start
    2: required i64 range_end
}

struct GetCardRangesRequest {
    1: required DirectoryServerProviderID provider_id
}

struct GetCardRangesResponse {
    1: required DirectoryServerProviderID provider_id
    2: required Timestamp                 last_updated_at
    3: required list<CardRange>           card_ranges
}

struct InitRBKMoneyPreparationFlowRequest {
    1: required DirectoryServerProviderID provider_id
    2: required MessageVersion            message_version
}

/** Вспомогательная информация по транзакции */
struct ChallengeFlowTransactionInfo {
    1: required ThreeDsServerTransactionID transaction_id
    2: required string                     device_channel
    3: required Timestamp                  decoupled_auth_max_time
    4: required string                     acs_dec_con_ind
    5: required DirectoryServerProviderID  provider_id
    6: required MessageVersion             message_version
    7: required string                     acs_url
}

service PreparationFlowService {

    /**
     * Требование инициировать обмен сообщениями между Storage и 3DS Server,
     * приводящий к обновлению карточных диапазонов в Storage
     *
     * НЕ приводит к обновлению карточных диапазонов в 3DS Server
     */
    void InitRBKMoneyPreparationFlow(1: InitRBKMoneyPreparationFlowRequest request)

}

service CardRangesStorage {

    /** Запрос на получение всех карточных диапазонов */
    GetCardRangesResponse GetCardRanges(1: GetCardRangesRequest request) throws (1: CardRangesNotFound ex1)

}

service ChallengeFlowTransactionInfoStorage {

    /** Запрос на сохранение информации по транзакции */
    void SaveChallengeFlowTransactionInfo(1: ChallengeFlowTransactionInfo transaction_info)

    /** Запрос на получение информации по транзакции */
    ChallengeFlowTransactionInfo GetChallengeFlowTransactionInfo(1: ThreeDsServerTransactionID transaction_id) throws (1: ChallengeFlowTransactionInfoNotFound ex1)

}
