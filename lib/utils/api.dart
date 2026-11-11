import 'debug.dart';

abstract class ApiConstant {
  /// --------------- API URLS -----------------------

  static const domain = "admin.dramabest.com";
  static const liveURL = "https://admin.dramabest.com/";
  static const SECRET_KEY = "Z-Gk6fCW?soYe-Q2KzKp7V2&gpF_anI";

  static const localURL = "http://192.168.1.66:6054/";

  static String getBaseURL() {
    if (Debug.isLocal) {
      return localURL;
    } else {
      return liveURL;
    }
  }

  static const login = "api/client/user/loginOrSignUp";

  static const getMoviesSeries = "api/client/movieSeries/fetchMoviesSeries";
  static const getMoviesGroupedByCategory = "api/client/movieSeries/getMoviesGroupedByCategory?";
  static const newReleasesVideo = "api/client/movieSeries/fetchNewReleasesForUser?";
  static const trendingMovieSeries = "api/client/movieSeries/getTrendingMoviesSeries?";

  static const createDailyCheckInRewardHistory = "api/client/dailyCoinReward/handleDailyCheckInReward?";
  static const createAdWatchRewardHistory = "api/client/user/handleAdWatchReward?";

  static const getVideosGroupedByMovieSeries = "api/client/shortVideo/getVideosGroupedByMovieSeries?";

  static const adRewardCoin = "api/client/adRewardCoin/getAdRewardByUser?";
  static const dailyRewardCoin = "api/client/dailyCoinReward/getDailyRewardCoinByUser?";

  // >>>>> >>>>> >>>>> Reels Api <<<<< <<<<< <<<<<

  static const fetchMovieSeriesTrailer = "api/client/shortVideo/getVideosGroupedByMovieSeries?";
  static const fetchEpisodeWiseVideo = "api/client/shortVideo/retrieveMovieSeriesVideosForUser?";
  static const createLikeDislikeOfVideo = "api/client/shortVideo/likeOrDislikeOfVideo?";
  static const createFavoriteVideo = "api/client/userVideoList/videoAddedToMyListByUser?";
  static const getFavoriteVideo = "api/client/userVideoList/getAllVideosAddedToMyListByUser?";

  static const getTransactionHistory = "api/client/history/retrieveUserSubscriptionHistory?";
  static const getEpisodeUnlockHistory = "api/client/history/getEpisodeUnlockHistory?";
  static const getEpisodeAutoUnlockHistory = "api/client/history/fetchEpisodeAutoUnlockHistory?";
  static const fetchRewardCoinHistoryByUser = "api/client/history/fetchCoinHistoryByUser?";

  static const fetchCoinPlanHistory = "api/client/history/fetchCoinplanHistoryOfUser?";
  static const retrieveSettingsForUser = "api/client/setting/retrieveSettingsForUser";
  static const fetchProfile = "api/client/user/fetchProfile?";
  static const getReportReason = "api/client/report/getReportReason";
  static const fetchCoinplanByUser = "api/client/coinplan/fetchCoinplanByUser";
  static const recordCoinPlanHistory = "api/client/coinplan/recordCoinPlanHistory?";
  static const fetchVipPlanByUser = "api/client/vipPlan/fetchVipPlanByUser";
  static const recordVipPlanHistory = "api/client/vipPlan/recordVipPlanHistory?";
  static const deleteUserAccount = "api/client/user/deleteUserAccount?";
  static const findContentBySearch = "api/client/movieSeries/findContentBySearch?";
  static const handleWatchHistoryCreation = "api/client/watchHistory/handleWatchHistoryCreation?";
  static const deductCoinForVideoView = "api/client/shortVideo/deductCoinForVideoView?";
  static const viewAdToUnlockVideo = "api/client/shortVideo/viewAdToUnlockVideo?";
  static const unlockEpisodesAutomatically = "api/client/shortVideo/unlockEpisodesAutomatically?";
  static const getMostSearched = "api/client/searchHistory/getMostSearched?";
  static const searchMovieSeries = "api/client/searchHistory/searchMovieSeries?";
  static const listCategory = "api/client/category/listCategory?";
  static const fetchGenreBasedMediaContent = "api/client/category/fetchGenreBasedMediaContent?";
  static const fetchTrendingMoviesSeries = "api/client/movieSeries/fetchTrendingMoviesSeries?";
  static const getLanguageList = "api/client/language/getLanguageList?";
  static const getFilterContent = "api/client/movieSeries/getFilterContent?";

  // >>>>> >>>>> Report Api <<<<< <<<<<

  static const fetchReport = "${liveURL}api/client/report/getReportReason";
  static const createReport = "${liveURL}api/client/report/reportByUser";

  // >>>>> >>>>> Localization Api <<<<< <<<<<
  static const fetchLanguages = "api/client/translation/findActive";
  static const fetchAll = "api/client/translation/findAll";
  static const fetchLanguageTranslations = "api/client/translation/find";
  static const fetchLatestLanguageVersion = "api/client/translation/latestVersion";
}
