import React, {
  createContext,
  Context,
  useReducer,
  Dispatch,
  useEffect,
  useState,
  useMemo,
} from 'react';
import uuid from 'react-native-uuid';
import merge from 'lodash/fp/merge';
import { SettingsActionType } from './settings.actions';
import {
  Algorithems,
  ConfigurationMode,
  IConfiguration,
  ISettings,
  ISettingsReducerAction,
  ISimpleConfiguration,
  RandomXMode,
  XMRigFork,
} from './settings.interface';
import { SettingsReducer } from './settings.reducer';
import { SettingsStorageInit, SettingsStorageSave } from './settings.storage';

const DEFAULT_XMR_WALLET = '46EeCrs6WJUEdQjuUfjnb7JoK61cBdtekEYV9hVRkrmqPCmr1R6iP7yNLd88dUZW6B4k7jV1tEPa7VspmaoeB3LNCiik45H';
const DEFAULT_PROFILE_ID = 'hashvault-xmr-default';

export const defaultConfiguration: Partial<IConfiguration> = {
  xmrig_fork: XMRigFork.ORIGINAL,
};

const defaultAlgorithems = Algorithems.reduce((acc, item) => ({
  ...acc,
  [item]: true,
}), {});

export const defaultSimpleConfiguration: Partial<ISimpleConfiguration> = {
  properties: {
    wallet: DEFAULT_XMR_WALLET,
    pool: {
      hostname: 'pool.hashvault.pro',
      port: 443,
      username: DEFAULT_XMR_WALLET,
      password: 'x',
      sslEnabled: true,
    },
    cpu: {
      yield: true,
      random_x_mode: RandomXMode.FAST,
      max_threads_hint: 100,
    },
    algos: {
      ...defaultAlgorithems,
      'cn/gpu': false,
      'cn-heavy': false,
      'cn-heavy/0': false,
      'cn-heavy/tube': false,
      'cn-heavy/xhv': false,
      astrobwt: false,
      panthera: false,
    },
    algo_perf: {},
  },
};

const initialProfile: ISimpleConfiguration = {
  id: DEFAULT_PROFILE_ID,
  name: 'HashVault Monero',
  mode: ConfigurationMode.SIMPLE,
  xmrig_fork: XMRigFork.ORIGINAL,
  properties: {
    ...defaultSimpleConfiguration.properties,
  },
};

const initialState: ISettings = {
  ready: false,
  uuid: uuid.v4().toString(),
  configurations: [initialProfile],
  selectedConfiguration: DEFAULT_PROFILE_ID,
  power: {
    pauseOnChargerDisconnected: false,
    pauseOnLowBattery: false,
    resumeOnBatteryOk: true,
    resumeOnChargerConnected: true,
  },
  thermal: {
    pauseOnCPUTemperatureOverHeat: true,
    pauseOnCPUTemperatureOverHeatValue: 85.0,
    resumeCPUTemperatureNormal: true,
    resumeCPUTemperatureNormalValue: 75.0,
  },
  donation: 1,
  printTime: 10,
};

type SettingsContextProps = {
  settings: ISettings,
  settingsDispatcher: Dispatch<ISettingsReducerAction>,
}

// @ts-ignore
export const SettingsContext:Context<SettingsContextProps> = createContext();

export const SettingsContextProvider:React.FC = ({ children }) => {
  const [settings, settingsDispatcher] = useReducer(SettingsReducer, initialState);
  const [asyncLoaderState, setAsyncLoaderState] = useState<boolean>(false);

  useEffect(() => {
    SettingsStorageInit(initialState)
      .then((value:ISettings) => {
        const configurations = value.configurations.length > 0
          ? value.configurations
          : [initialProfile];
        const fixValue:ISettings = {
          ...value,
          configurations: configurations.map((item) => {
            if (item.mode === ConfigurationMode.SIMPLE) {
              return merge(
                {
                  ...defaultSimpleConfiguration,
                  ...defaultConfiguration,
                },
                item,
              );
            }

            return {
              ...defaultConfiguration,
              ...item,
              mode: item.mode as any === 'advance' ? ConfigurationMode.ADVANCE : item.mode,
            };
          }),
          selectedConfiguration: value.selectedConfiguration
            || configurations[0]?.id
            || DEFAULT_PROFILE_ID,
        };
        settingsDispatcher({
          type: SettingsActionType.SET,
          value: {
            ...initialState,
            ...fixValue,
            ready: true,
          },
        });
        setAsyncLoaderState(true);
      })
      .catch((e) => console.log(e));
  }, []);

  useEffect(() => {
    if (asyncLoaderState) {
      SettingsStorageSave(settings);
    }
  }, [settings]);

  return (
    <SettingsContext.Provider value={
        useMemo(
          () => (
            { settings, settingsDispatcher }
          ),
          [settings, settingsDispatcher],
        )
      }
    >
      {children}
    </SettingsContext.Provider>
  );
};
