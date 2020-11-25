namespace java com.rbkmoney.damsel.three_ds_server_storage
namespace erlang three_ds_server_storage

typedef string ThreeDsServerTransactionID
typedef string DirectoryServerProviderID
typedef string Timestamp
typedef string MessageVersion

exception ChallengeFlowTransactionInfoNotFound {}
exception DirectoryServerProviderIDNotFound {}

/** Карточный диапазон */
struct CardRange {
    1: required i64     range_start
    2: required i64     range_end
    3: required Action  action
    4: optional string  three_ds_method_url
}

union Action {
    1: Add      add_card_range
    2: Delete   delete_card_range
    3: Modify   modify_card_range
}

struct Add {}
struct Delete {}
struct Modify {}

struct InitRBKMoneyPreparationFlowRequest {
    1: required DirectoryServerProviderID provider_id
    2: required MessageVersion            message_version
}

struct UpdateCardRangesRequest {
    1: required DirectoryServerProviderID   provider_id
    2: required MessageVersion              message_version
    3: required list<CardRange>             card_ranges
    4: required string                      serial_number
    5: required bool                        is_need_storage_clear
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

service PreparationFlowInitializer {

    /**
     * Требование к Storage инициировать обновление карточных диапазонов через 3DS Server
     */
    void InitRBKMoneyPreparationFlow(1: InitRBKMoneyPreparationFlowRequest request)

}

service CardRangesStorage {

    void updateCardRanges(1: UpdateCardRangesRequest request)

    bool IsStorageEmpty(1: DirectoryServerProviderID provider_id)

    bool IsValidCardRanges(1: DirectoryServerProviderID provider_id, 2: list<CardRange> card_ranges)

    DirectoryServerProviderID GetDirectoryServerProviderId(1: i64 account_number) throws (1: DirectoryServerProviderIDNotFound ex1)

}

service ChallengeFlowTransactionInfoStorage {

    /** Запрос на сохранение информации по транзакции */
    void SaveChallengeFlowTransactionInfo(1: ChallengeFlowTransactionInfo transaction_info)

    /** Запрос на получение информации по транзакции */
    ChallengeFlowTransactionInfo GetChallengeFlowTransactionInfo(1: ThreeDsServerTransactionID transaction_id) throws (1: ChallengeFlowTransactionInfoNotFound ex1)

}
