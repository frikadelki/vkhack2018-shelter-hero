package com.piggybank.sh.backend

import com.piggybank.sh.backend.db.*
import com.piggybank.sh.generated.Shelter
import com.piggybank.sh.generated.ShelterMapObject
import com.piggybank.sh.genex.geoPoint
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SchemaUtils
import org.jetbrains.exposed.sql.transactions.transaction

class SHRepo(private val db: Database) {
    init {
        transaction(db) {
            SchemaUtils.create(
                    VolunteersTable,
                    VenuesTable,
                    SheltersTable,
                    SheltersOrdersTable,
                    OrderDemandsTable)
        }

        initSheltersData()
    }

    private fun initSheltersData()
    {
        val sheltersData : Array<String> = arrayOf(
              "Муркоша, 55.881332, 37.678433"
            , "Дубовая роща, 55.818184, 37.615347"
            , "Печатники, 55.663256, 37.716034"
            , "Приют для бездомных собак, 55.786896, 37.505687"
            , "Берта, 55.924495, 38.013445"
            , "Приют для безнадзорных животных, 55.864162, 37.654106"
            , "В добрые руки БФ, 55.927808, 37.435551"
            , "Супер собака, 55.913694, 37.388363"
            , "Шереметьевский приют для амстафов и питбулей, 55.953331, 37.349342"
            , "Витус+ Приют Для Бездомных Животных, 55.916791, 37.368777"
            , "Ласковый Зверь, 55.850306, 37.573237"
            , "ГАВ, 55.894183, 37.443058"
            , "Приют для бродячих животных № 10, 55.843836, 37.679772"
            , "Нордогс, 55.836071, 37.506954"
            , "Приют для безнадзорных животных, 55.817882, 37.606373"
            , "Приют Бирюлево, 55.583107, 37.617149"
            , "С красной горки, 55.833306, 37.314277"
            , "Приют для безнадзорных животных ГБУ ДОРИНВЕСТ, 55.978570, 37.265321"
        )

        transaction(db) {
            for (shelterData: String in sheltersData) {
                val splitted : List<String> = shelterData.split(',')

                ShelterEntity.new {
                    name = splitted[0].trim()
                    iconName = "shelter"
                    location = geoPoint(splitted[1].trim().toDouble(), splitted[2].trim().toDouble())
                }
            }
        }
    }

    fun shelterMapObjects(): Iterable<ShelterMapObject> = transaction(db) {
        return@transaction ShelterEntity.all().map {
            return@map ShelterMapObject.newBuilder()
                    .setShelter(it.shelter())
                    .addAllAvailableOrders(emptyList())
                    .build()
        }
    }
}

fun ShelterEntity.shelter(): Shelter {
    return Shelter.newBuilder()
            .setId(id.value)
            .setName(name)
            .setIconName(iconName)
            .setCoordinate(location)
            .build()
}