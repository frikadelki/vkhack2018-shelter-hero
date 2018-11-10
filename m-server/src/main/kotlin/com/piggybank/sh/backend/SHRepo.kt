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
        initVenuesData()
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

    private fun initVenuesData()
    {
        val venuesData : Array<String> = arrayOf(
              "Зоомагазин Зверушка, service, 55.590124, 37.374826, pet-shop, cash-box"
            , "Пункт сбора Филевский парк, box, 55.737702, 37.478849, box"
            , "Пункт сбора Борисово, box, 55.635847, 37.719047, box"
            , "Пункт сбора Чертаново, box, 55.602277, 37.611149, box"
            , "Cтудия ZooRoom, service, 55.546560, 37.705507, service, cash-box"
            , "Ветклиника в Красногорске, clinic, 55.814771, 37.365914, clinic, cash-box"
            , "Вет. клиника Биоконтроль, clinic, 55.656013, 37.641062, clinic, cash-box"
            , "Центр красоты 100Лица, cash-box, 55.748323, 37.420387, cash-box"
            , "Ветеринарный центр Комондор, clinic, 55.723793, 37.159622, clinic, cash-box"
            , "Ветеринарная клиника Вет-ОК, clinic, 55.686314, 37.738186, clinic, cash-box"
            , "Ветеринарная клиника Орикс, clinic, 55.796249, 37.483648, clinic, cash-box"
            , "Зоомагазин Зоосити, service, 55.814643, 37.566080, pet-shop, cash-box"
            , "Пункт сбора Мичуринский проспект, box, 55.701207, 37.506946, box"
            , "Круглосуточная ветклиника Алисавет, clinic, 55.684885, 37.481822, clinic, cash-box"
            , "Круглосуточная ветклиника Алисавет, clinic, 55.550216, 37.538991, clinic, cash-box"
            , "Семейная аптека Фарм Фемели, cash-box, 55.593979, 37.366937, cash-box"
            , "Круглосуточная ветклиника Аист-Вет Одинцово, clinic, 55.694051, 37.327547, clinic, cash-box"
            , "Ветеринарная клиника Умка, clinic, 55.812939, 37.583095, clinic, cash-box"
            , "Пункт сбора Лефортово, box, 55.774419, 37.710930, box"
            , "Пункт сбора Тушино, box, 55.866796, 37.443501, box"
            , "Ветеринарная клиника Фауна, clinic, 55.803757, 37.834775, clinic, cash-box"
            , "Зоомагазин Лабрадор, service, 55.771309, 37.683042, pet-shop, cash-box"
            , "Зоомагазин Лабрадор, service, 55.736982, 37.632189, pet-shop, cash-box"
            , "Аптека-музей, cash-box, 55.569181, 37.471819, cash-box"
            , "Груминг-салон Боншери, service, 55.830965, 37.354669, service, cash-box"
            , "Зоомагазин Соня, service, 55.584181, 37.735842, pet-shop, cash-box"
            , "Ветеринарная клиника Беланта, clinic, 55.633471, 37.766747, clinic, cash-box"
            , "Ветеринарная клиника Беланта, clinic, 55.503038, 37.571488, clinic, cash-box"
            , "Ветеринарная клиника В мире животных, clinic, 55.710806, 37.891922, clinic, cash-box"
            , "Ветклиника Свой Доктор Кунцево, clinic, 55.724446, 37.410664, clinic, cash-box"
            , "Круглосуточная ветеринарная клиника Поливет, clinic, 56.011237, 37.201281, clinic, cash-box"
            , "Ветернарная клиника Свой доктор Котельники, clinic, 55.662691, 37.858005, clinic, cash-box"
            , "Вет. клиника Идеал, clinic, 55.936290, 37.778586, clinic, cash-box"
            , "Вет. клиника Пантера, clinic, 55.456447, 38.444389, clinic, cash-box"
            , "Пункт сбора Марфино, box, 55.830833, 37.587686, box"
            , "Ветеринарный центр Ковчег, clinic, 55.782295, 37.702719, clinic, cash-box"
            , "Центр ветеринарной офтальмологии доктора А.Г. Шилкина, clinic, 55.852214, 37.645559, clinic, cash-box"
            , "Центр ветеринарной офтальмологии доктора А.Г. Шилкина, clinic, 55.789224, 37.789037, clinic, cash-box"
            , "Зоомагазин Боряша, service, 55.827697, 37.595323, pet-shop, cash-box"
            , "Ветклиника Бимка, clinic, 56.157896, 37.941574, clinic, cash-box"
            , "Ветклиника Бимка, clinic, 56.082119, 37.924280, clinic, cash-box"
            , "Ветеринарная клиника 10 жизней, clinic, 55.598703, 38.178499, clinic, cash-box"
            , "Ветеринарная клиника 10 жизней, clinic, 55.604863, 38.092787, clinic, cash-box"
            , "Зоомагазин Боряша, service, 55.827710, 37.598542, pet-shop, cash-box"
            , "Магазин разливных напитков Хмельной Кот, cash-box, 55.789826, 37.479592, cash-box"
            , "Дог-центр Craft Master, service, 55.841724, 37.443765, service, cash-box"
            , "Ветклиника ВетЭгида, clinic, 56.012609, 37.837509, clinic, cash-box"
            , "Сеть клиник 101 Далматинец, clinic, 55.856203, 37.449733, clinic, cash-box"
            , "Ветеринарная клиника ЗооДубна, clinic, 56.744564, 37.193386, clinic, cash-box"
            , "Ветеринарная клиника ЗооДубна, clinic, 56.737253, 37.170260, clinic, cash-box"
            , "Ветеринарная клиника ЗооДубна, clinic, 56.731650, 37.149772, clinic, cash-box"
            , "Зооцентр КиС, service, 55.674541, 37.445070, service, box"
            , "Сеть клиник 101 Далматинец, clinic, 55.903194, 37.404066, clinic, cash-box"
            , "Сеть клиник 101 Далматинец, clinic, 55.941968, 37.299949, clinic, cash-box"
            , "Магазин Фруктовая лавка, cash-box, 55.771833, 37.583987, cash-box"
            , "Центр ветеринарной МРТ-диагностики Ветцентр СТ, clinic, 55.625701, 37.675739, clinic, cash-box"
            , "Многопрофильный ветеринарный центр Dr.Hug, service, 55.777060, 37.539112, service, box"
        )

        transaction(db) {
            for (venueData: String in venuesData) {
                val splitted : List<String> = venueData.split(',')

                VenueEntity.new {
                    name = splitted[0].trim()
                    iconName = splitted[1].trim()
                    location = geoPoint(splitted[2].trim().toDouble(), splitted[3].trim().toDouble())

                    val tagsInternal = mutableListOf<String>()
                    for (i in 4 .. splitted.size) {
                        tagsInternal.add(splitted[i].trim())
                    }

                    tags = tagsInternal
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